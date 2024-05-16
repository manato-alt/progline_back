class SharedCodesController < ApplicationController
  def index
    user = User.find_by(uid: params[:user_id])
    shared_code = user.shared_code

    render json: shared_code, status: :ok
  end

  def create_name
    user = User.find_by(uid: params[:user_id])
    if user
      shared_code = user.shared_code || SharedCode.new(user: user)
      if shared_code.update(public_name: params[:public_name])
        render json: { message: "Public name updated successfully" }, status: :ok
      else
        render json: { error: "Failed to update public name" }, status: :unprocessable_entity
      end
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def create_code
    user = User.find_by(uid: params[:user_id])
    if user
      shared_code = user.shared_code || SharedCode.new(user: user)
      if shared_code.update(code: generate_unique_code)
        render json: { message: "Code generated successfully", shared_code: shared_code }, status: :ok
      else
        render json: { error: "Failed to generate code" }, status: :unprocessable_entity
      end
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def delete_code
    user = User.find_by(uid: params[:user_id])
    if user
      if user.shared_code.update(code: nil)
        render json: { message: "Code deleted successfully", shared_code: user.shared_code }, status: :ok
      else
        render json: { error: "Failed to delete code" }, status: :unprocessable_entity
      end
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def generate_unique_code
    SecureRandom.hex(10)
  end

end
