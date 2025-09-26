# spec/controllers/posts_controller_spec.rb
require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:bearer_token) { jwt_token_1(user) }
  let(:image_file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/test_image.png'), 'image/png') }

  before do
    request.headers['Authorization'] = "Bearer #{bearer_token}"
  end

  let(:valid_params) do
    {
      posts: {
        caption: 'caption',
        photos: [image_file]
      }
    }
  end

  describe 'GET #index' do
    let!(:post1) { create(:post, user: user) }
    let!(:post2) { create(:post, user: other_user) }

    it 'returns all posts' do
      get :index
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(2)
    end
  end

  describe 'GET #show' do
    let!(:post1) { create(:post, user: user) }

    it 'returns the post' do
      get :show, params: { id: post1.id }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(post1.id)
    end
  end

  describe 'POST #create' do
    it 'creates a new post with valid params' do
      expect do
        post :create, params: valid_params
      end.to change(Post, :count).by(1)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['caption']).to eq('caption')
      expect(json['id']).to be_present
    end

    it 'returns errors for invalid params' do
      post :create, params: { posts: { caption: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json).to include("Caption can't be blank", "Photos can't be blank")
    end
  end

  describe 'PATCH #update' do
    let!(:post1) { create(:post, user: user, caption: 'Old caption') }

    it 'updates post with valid params' do
      patch :update, params: { id: post1.id, posts: { caption: 'New caption' } }
      expect(response).to have_http_status(:ok)
      expect(post1.reload.caption).to eq('New caption')
    end

    it 'fails to update another user post' do
      post_other = create(:post, user: other_user)
      patch :update, params: { id: post_other.id, posts: { caption: 'New' } }
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Post not found')
    end
  end

  describe 'DELETE #destroy' do
    let!(:post1) { create(:post, user: user) }

    it 'deletes own post' do
      expect do
        delete :destroy, params: { id: post1.id }
      end.to change(Post, :count).by(-1)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('Post Deleted Succesfull')
    end

    it 'cannot delete another user post' do
      post_other = create(:post, user: other_user)
      delete :destroy, params: { id: post_other.id }
      expect(response).to have_http_status(404)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Post not found')
    end
  end
end
