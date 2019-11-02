# frozen_string_literal: true

class Api::V1::OffersController < ApplicationController
  before_action :set_offer, only: %i[show update destroy]

  # GET /offers
  # Params:
  #   - limit: (default: 50) Number of offers to display
  #   - offset: (default: 0) Number of offers to skip first
  #     Why offset instead of commonly used page number?
  #     When changing number of items displayed on page you can still get right starting offer on page.
  #   - min_price: (default: any) minimum price inclusive
  #   - max_price: (default: any) maximum price inclusive
  def index
    limit = params[:limit].to_i.positive? ? params[:limit].to_i : 50
    offset = params[:offset].to_i.positive? ? params[:offset].to_i : 0
    @offers = Offer.all.order(created_at: :desc).limit(limit).offset(offset)
    @offers.where!('price >= ?', params[:min_price].to_f) if params[:min_price]&.match? /\A\d+(\.\d+)?\Z/
    @offers.where!('price <= ?', params[:max_price].to_f) if params[:max_price]&.match? /\A\d+(\.\d+)?\Z/
  end

  # GET /offers/1
  def show; end

  # POST /offers
  def create
    @offer = Offer.new(offer_params)

    respond_to do |format|
      if @offer.save
        format.json { render :show, status: :created }
      else
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1
  def update
    respond_to do |format|
      if @offer.update(offer_params)
        format.json { render :show, status: :ok }
      else
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  def destroy
    @offer.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:title, :description, :price, :picture)
  end
end
