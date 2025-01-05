class StoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    # users = User.joins(:stories).where('stories.expires_at > ?', Time.current).distinct
    users = User.joins(:stories).distinct
    serialized_users = ActiveModelSerializers::SerializableResource.new(users, each_serializer: UserSerializer).as_json
    render json: {stories: serialized_users}
  end
  
  
  def create
    @story = @current_user.stories.build(story_params)
    @story.expires_at = 24.hours.from_now

    if @story.save
      render json: @story, status: :created
    else
      render json: @story.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @story = @current_user.stories.find(params[:id])
    @story.destroy
    head :no_content
  end

  private

  def story_params
    params.require(:story).permit(:image_url, :image, :video)
  end
end
