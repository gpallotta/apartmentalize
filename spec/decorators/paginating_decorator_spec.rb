require 'spec_helper'

describe PaginatingDecorator do

  it "adds pagination methods to a decorated collection" do
    arr = []
    arr << FactoryGirl.create(:claim)
    arr = Kaminari.paginate_array(arr)
    decorated_list = PaginatingDecorator.decorate(arr)
    expect(decorated_list).to respond_to(:current_page)
    expect(decorated_list).to respond_to(:total_pages)
    expect(decorated_list).to respond_to(:limit_value)
    expect(decorated_list[0]).to respond_to(:paid_status)
  end

end
