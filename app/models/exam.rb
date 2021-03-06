class Exam < ApplicationRecord
  belongs_to :course

  has_many :grades
  has_many :students, through: :grades

  # Validations
  validates :title,
            presence: true,
            length: {maximum: 20}

  validates :description,
            length: {maximum: 255}
  
  validates :min_grade,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :exam_date,
            presence: true,
            allow_blank: false
  
  validates :course,
            presence: true

  # callbacks
  before_destroy :erase_related_grades

  def approved_students
   self.grades.where('grade>=?', self.min_grade).size
  end

  def unapproved_students
    self.grades.where('grade<?', self.min_grade).size
  end

  def absent_students
    self.course.students.size - self.grades.size
  end

  def approved_rate
    rate = Float(self.approved_students) / Float(self.grades.count) * 100.0
    if !rate.finite?
      0
    else
      rate.truncate 2
    end
  end

  def to_s
    self.title
  end

  def students_without_grades
    self.course.students - self.students
  end
  private
  def erase_related_grades
    self.grades.destroy_all
  end
end
