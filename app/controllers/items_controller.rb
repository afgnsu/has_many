class ItemsController < ApplicationController
  before_action :set_item, only: [:edit, :show, :update, :destroy , :multi , :multi_save]

  # GET /items
  def index
    @items = Item.all
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  def show
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to items_path, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      redirect_to items_path, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    redirect_to items_url, notice: 'Item was successfully destroyed.'
  end

  def multi
    @item_childs = ItemChild.where(:item_id => @item.id)
  end

  def multi_save
    #取出所有關連id
    ids = (params[:ic_old] || {}).keys.map{|i|i.to_i}

    #語意：排除送出的id之外的所有隸屬item的都刪除
    ItemChild.where("item_id = #{@item.id} AND id NOT IN (#{ids.join(',')})").delete_all

    #更新舊的資料
    if params[:ic_old]
      params[:ic_old].each_pair do |id , data|
        ic = ItemChild.where(:item_id => @item.id , :id => id).first
        if ic
          #這邊要過 permit 或是一個一個指定都行
          ic.update_attributes(:name => data[:name] , :age => data[:age])
        end
      end
    end

    #額外新增的都再塞入
    if params[:ic]
      params[:ic][:name].each_index do |index|
        ItemChild.create(:item_id => @item.id , :name => params[:ic][:name][index] , :age => params[:ic][:age][index])
      end
    end
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name)
    end
end
