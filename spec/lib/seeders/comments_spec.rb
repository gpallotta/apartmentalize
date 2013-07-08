require 'spec_helper'

describe Seeders::Comments do

  let(:seeder) { Seeders::Comments }
  before(:each) do
    Seeders::Users.seed
    Seeders::Claims.seed
  end

  it "creates comments for each claim" do
    comment_count = Comment.count
    seeder.seed
    expect(Comment.count).not_to eq(comment_count)
  end

  it 'can be run multiple times without duplication' do
    seeder.seed
    comment_count = Comment.count
    seeder.seed
    expect(Comment.count).to eq(comment_count)
  end


end
