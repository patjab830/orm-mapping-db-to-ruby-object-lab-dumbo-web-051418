require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql_get_all = <<-SQL
      SELECT * FROM students;
    SQL

    DB[:conn].execute(sql_get_all).map {|row| Student.new_from_db(row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql_find_by_name = <<-SQL
      SELECT * FROM students WHERE name = ?;
    SQL

    DB[:conn].execute(sql_find_by_name, name).map do |row|
      Student.new_from_db(row)
    end[0] # because you want to return an instance of the object and not the array
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql_grade_9 = <<-SQL
      SELECT COUNT(*) FROM students WHERE grade = 9;
    SQL
    DB[:conn].execute(sql_grade_9)[0]
    # note to patrick: understand more of what SQL statements return
  end

  def self.students_below_12th_grade
    sql_grade_below_12 = <<-SQL
      SELECT * FROM students WHERE grade < 12;
    SQL

    ## Instance needed
    DB[:conn].execute(sql_grade_below_12).map do |row|
      Student.new_from_db(row)
    end
  end

  # returns an array of the first X students in grade 10
  def self.first_X_students_in_grade_10(x)
    sql_first_x_grade_10 = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?;
    SQL

    DB[:conn].execute(sql_first_x_grade_10, x).map do |row|
      Student.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1).first
  end

  def self.all_students_in_grade_X(x)
    sql_grade_x = <<-SQL
      SELECT * FROM students WHERE grade = ?;
    SQL

    DB[:conn].execute(sql_grade_x, x).map do |row|
      Student.new_from_db(row)
    end
  end
end
