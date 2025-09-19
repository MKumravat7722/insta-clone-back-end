require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }

  describe "GET #show" do
    it "returns the user" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(user.id)
    end

    it "returns 404 if user not found" do
      get :show, params: { id: 999999 }
      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("User not found")
    end
  end

  describe "POST #create" do
    it "creates a new user" do
      user_params = attributes_for(:user)
      post :create, params: { user: user_params }
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["user"]["email"]).to eq(user_params[:email])
    end

    it "returns errors if invalid" do
      post :create, params: { user: { email: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to be_present
    end
  end

  describe "PATCH #update" do
    it "updates the user" do
      patch :update, params: { id: user.id, user: { full_name: "Updated Name" } }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["full_name"]).to eq("Updated Name")
    end
  end

  describe "DELETE #destroy" do
    it "deletes the user" do
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("User deleted successfully")
    end
  end

  describe "GET #search" do
    it "returns matching users" do
      get :search, params: { query: user.username }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first["username"]).to eq(user.username)
    end
  end
end
