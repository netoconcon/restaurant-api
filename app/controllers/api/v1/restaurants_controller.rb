class Api::V1::RestaurantsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :set_restaurant, only: [:show, :update]

  def index
    @restaurants = policy_scope(Restaurant)
  end

  def show
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    authorize @restaurant
    if @restaurant.save
      render :show
    else
      render_error
    end
  end

  # On Postman

  # verb: Post
  # url: http://localhost:3000/api/v1/restaurants

  # key: Content-Type value: application/json
  # key: X-User-Email value: neto@teste.com.br
  # key: X-User-Token value: yMC416U4sovtYnxAfDgb

  # { "restaurant": { "name": "New Pizza", "address": "London 2" } }

  def update
    if @restaurant.update(restaurant_params)
      render :show
    else
      render_error
    end
  end

  # update on CLI

  # curl -i -X PATCH                                        \
  #      -H 'Content-Type: application/json'              \
  #      -H 'X-User-Email: seb@lewagon.org'               \
  #      -H 'X-User-Token: a6hYpzsfNJdYC6zEMxs3'          \
  #      -d '{ "restaurant": { "name": "New name" } }'    \
  #      http://localhost:3000/api/v1/restaurants/1

  # update on Postman

  # verb: PATCH
  # url: http://localhost:3000/api/v1/restaurants/1

  #headers:

  # key: Content-Type value: application/json
  # key: X-User-Email value: neto@teste.com.br
  # key: X-User-Token value: yMC416U4sovtYnxAfDgb

  # body (set as raw)

  # { "restaurant": { "name": "Le Wagon Food" } }


  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end

  def render_error
    render json: { errors: @restaurant.errors.full_messages },
      status: :unprocessable_entity
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :address)
  end
end
