# encoding: UTF-8
require 'spec_helper'

describe Guide do

  describe "validations" do

    it "ensures names are unique" do
      Guide.any_instance.stub(:create_template).and_return(true)
      FactoryGirl.create(:guide, name: "My New Name", subject: "string")
      FactoryGirl.build(:guide, name: "My New Name").should_not be_valid
    end

  end

  describe "create" do

    it "creates a file whose name is name of instance and extension html.erb in guides directory" do
      file = mock('file')
      Guide.any_instance.stub(:file_name).and_return("some_name")
      data = File.read(Rails.root.join('app','views','guides','template.txt')).sub("Title","Some Name")
      File.should_receive(:open).with(Rails.root.join('app','views','guides','_some_name.html.erb'),"w").and_yield(file)
      file.should_receive(:write).with(data)
      FactoryGirl.create(:guide, name: "Some Name", subject: "my subject")
    end

    it "does not create a file if one already exists" do
      file = mock('file')
      Guide.any_instance.stub(:file_name).and_return("my_new_name")
      File.should_not_receive(:open)
      FactoryGirl.create(:guide, name: "My New Name", subject: "my subject")
    end

  end

  describe "destroy" do

    it "deletes the associated view file" do
      Guide.any_instance.stub(:create_template).and_return(true)
      FactoryGirl.create(:guide, name: "My New Name", subject: "my subject")
      File.should_receive(:delete).with(Rails.root.join('app','views','guides','_my_new_name.html.erb')).and_return(1)
      Guide.find_by_name("My New Name").destroy
    end

    it "handles the case where file does not exist" do
      Guide.any_instance.stub(:create_template).and_return(true)
      FactoryGirl.create(:guide, name: "other name")
      File.should_not_receive(:delete)
      Guide.find_by_name("other name").destroy
    end

  end

  describe "file_name" do

    it "creates the right name" do
      Guide.any_instance.stub(:create_template).and_return(true)
      guide = FactoryGirl.create(:guide, name: "Some Namé with Áccents")
      guide.file_name.should == "some_name_with_accents"
    end

  end

  # describe "rename" do

  #   it "adds an _ to the start of the file" do
  #     Guide.any_instance.stub(:create_template).and_return(true)
  #     Guide.any_instance.stub(:file_name).and_return("my_file_name")
  #     File.stub(:exist?).and_return(true)
  #     File.should_receive(:rename).with(Rails.root.join("app","views","guides","my_file_name.html.erb"),Rails.root.join("app","views","guides","_my_file_name.html.erb")).and_return(0)
  #     guide = FactoryGirl.create(:guide, name: "my File Name")
  #     guide.rename
  #   end

  # end

  describe "reformat" do

    it "removes divs" do
      Guide.any_instance.stub(:create_template).and_return(true)
      Guide.any_instance.stub(:file_name).and_return("_my_new_name")
      file = mock('file')
      File.stub(:read).and_return(file)
      file.should_receive(:gsub).with(/((<div id="main-content">)|(<div id="guide_body">)|(<\/div>))/,"")
      File.stub(:open)
      guide = FactoryGirl.create(:guide, name: "some file name")
      guide.reformat
    end

  end

  describe "update" do

    it "renames file if name has changed" do
      Guide.any_instance.stub(:create_template).and_return(true)
      FactoryGirl.create(:guide, name: "My New Name", subject: "my subject")
      File.should_receive(:rename).with(Rails.root.join("app","views","guides","_my_new_name.html.erb"), Rails.root.join("app","views","guides","_my_second_name.html.erb"))
      Guide.find_by_name("My New Name").update_attributes(name: "My Second Name")
    end

    it "does not rename file if name was not changed" do
      Guide.any_instance.stub(:create_template).and_return(true)
      FactoryGirl.create(:guide, name: "My New Name", subject: "my subject")
      File.should_not_receive(:rename)
      Guide.find_by_name("My New Name").update_attributes(subject: "another subject")
    end

  end

end
