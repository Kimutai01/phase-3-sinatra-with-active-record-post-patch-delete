class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

  get '/reviews' do
    reviews = Review.all.order(:score).limit(10)
    reviews.to_json(include: {
      user: { only: [:name] },
      game: { only: [:title] }
    })

  end

  get '/reviews/:id' do
    review = Review.find(params[:id])

    review.to_json(include: {
      user: { only: [:name] },
      game: { only: [:title] }
    })
  end

  post '/reviews' do
    review = Review.create(
      comment: params[:comment],
      score: params[:score],
      user_id: params[:user_id],
      game_id: params[:game_id]
    )

    review.to_json
  end

  patch '/reviews/:id' do
    review = Review.find(params[:id])
    review.update(
      score: params[:score],
      comment: params[:comment]
    )
    review.to_json
  end

  delete '/reviews/:id' do
    review = Review.find(params[:id])
    review.destroy
    review.to_json
  end

end
