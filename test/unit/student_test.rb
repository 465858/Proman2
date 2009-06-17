# Copyright 2009 Swansea University
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

require 'test_helper'

class StudentTest < ActiveSupport::TestCase

  should_belong_to :user, :discipline
  should_have_one :project, :dependent => :nullify
  should_have_one :project_selection, :dependent => :destroy

  should_validate_presence_of :student_id, :discipline_id
  should_validate_uniqueness_of :student_id
  should_validate_numericality_of :student_id
  should_ensure_length_in_range :student_id, (6..255)
  should_validate_numericality_of :grade
  should_ensure_value_in_range :grade, (0..100)

  
  def setup
    @student = students(:student1)
    @user = users(:student1)
    @icct = disciplines(:icct)
  end

  # Replace this with your real tests.
  test "student has a user" do
    assert_equal @user, @student.user, "Student 1 wasn't owned by user student1"
  end

  test "student fields" do
    #student1:
    #  id: 1
    #    user_id: 201
    #    student_id: 382392
    #    discipline_id: 1
    #    grade: 99.9
    assert_equal @user.id, @student.user_id
    assert_equal '382392', @student.student_id
    assert_equal @icct, @student.discipline
    assert @student.grade > 99.0
  end

  test "delegated user methods" do
     assert_equal @user.email, @student.email
     assert_equal @user.name.to_s, @student.name.to_s
  end

  test "chained access methods still work" do
    assert_equal @icct.name, @student.discipline.name
    assert_equal @icct.long_name, @student.discipline.long_name
  end

  test "delegated discipline methods" do
    assert_equal @icct.name, @student.disc_name
    assert_equal @icct.long_name, @student.disc_long_name
  end
end
