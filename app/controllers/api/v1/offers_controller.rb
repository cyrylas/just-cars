# frozen_string_literal: true"

class Api::V1::OffersController < ApplicationController
  before_action :set_offer, only: %i[show update destroy]

  # GET /offers
  def index
    @offers = Offer.all
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
