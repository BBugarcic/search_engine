class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  # GET /products
  # GET /products.json
  def index
    # processing q parameter
    if ((params[:q] != "" && params[:q]))
      search_term = params[:q]
      search_term_arr = search_term.split(",").map do |e| e.strip end
      description_ids = Description.where(:label => search_term_arr).pluck(:id)
      @q_products = Product.joins(:describings).where(:describings => {:description_id => description_ids} ).distinct
    else
      @q_products = Product.all
    end

    # processiong category parameters
    if params[:category]
      @products = @q_products.where(:price_category => params[:category])
    else
      @products = @q_products
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    #get ids of similar products
    product_ids_and_counts = Describing.similar_product_ids_and_counts(@product)
    #get similar products
    num_attributes = @product.descriptions.length
    @similar_products_and_similarity = []
    product_ids_and_counts.each do |p_id, c|
      similar_product = []
      similar_product.push(Product.where(:id => p_id).first)
      similar_product.push(c.to_f/num_attributes * 100)
      @similar_products_and_similarity.push(similar_product)
    end
    @similar_products_and_similarity
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    updated_params = format_price(product_params)

    @product = Product.new(updated_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :price, :all_descriptions, :category)
    end

    def format_price(submitted_params)
      params = convert_price_to_cents(submitted_params)
      if (params[:price].to_f <= 2) then
        params[:price_category] = 0
      elsif (params[:price].to_f > 2 && params[:price].to_f <= 4 ) then
        params[:price_category] = 1
      else
        params[:price_category] = 2
      end

      params
    end

    def convert_price_to_cents(submitted_params)
      submitted_params[:price] = submitted_params[:price].to_f * 100 #convert to cents
      submitted_params
    end
end
