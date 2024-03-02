class EmployeesController < ApplicationController
  before_action :current_employee, only: [:show, :update, :destroy]

  def index
    @employees = Employee.includes(:contact_numbers)
    render json: @employees, include: :contact_numbers
  end

  def show
    render json: @employee, include: :contact_numbers
  end

  def create
    @employee = Employee.new(whitelist_params)

    if @employee.save
      render json: { message: 'Employee created successfully', employee: @employee }, status: :created
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update(whitelist_params)
      render json: { message: 'Employee updated successfully', employee: @employee }
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    render json: { message: 'Employee deleted successfully' }
  end

  def tax_deduction
    @employees = Employee.all
    tax_deductions = @employees.map { |employee| employee_tax_details(employee) }
    render json: tax_deductions
  end

  private

  def employee_tax_details(employee)
    yearly_salary = calculate_yearly_salary(employee)
    tax_amount = calculate_tax_details(yearly_salary)
    cess_amount = calculate_cess_details(yearly_salary)

    {
      employee_code: employee.id,
      first_name: employee.first_name,
      last_name: employee.last_name,
      yearly_salary: yearly_salary,
      tax_amount: tax_amount,
      cess_amount: cess_amount
    }
  end

  def calculate_yearly_salary(employee)
    current_date = Date.today
    doj = employee.joining_date

    start_date = [doj, Date.new(doj.year, 4, 1)].max
    end_date = [current_date, Date.new(current_date.year, 3, 31)].min

    # Ensure accurate months count for an employee
    months_worked = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month) + 1
    yearly_salary = employee.monthly_salary * months_worked

    return yearly_salary
  end

  def calculate_tax_details(yearly_salary)
    case yearly_salary
    when 0..250000
      0
    when 250001..500000
      (yearly_salary - 250000) * 0.05
    when 500001..1000000
      12500 + (yearly_salary - 500000) * 0.1
    else
      37500 + (yearly_salary - 1000000) * 0.2
    end
  end

  def calculate_cess_details(yearly_salary)
    if yearly_salary > 2500000
      cess_amount = (yearly_salary * 0.02)
    else
      cess_amount = 0
    end
    return cess_amount
  end

  def whitelist_params
    params.require(:employee).permit(:first_name, :last_name, :email, :joining_date, :monthly_salary, contact_numbers_attributes: [:mobile_number])
  end
end
