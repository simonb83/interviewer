class Guide < ActiveRecord::Base

  attr_accessible :name, :subject

  validates_uniqueness_of :name, :case_sensitive => false

  after_create :create_template
  after_destroy :remove_template
  after_update :rename_template

  DATA = File.read(Rails.root.join("app","views","guides","template.txt"))

  def create_template
    new_name = Rails.root.join('app','views','guides',"_"+self.file_name+".html.erb")
    unless File.exist?(new_name)
      data = DATA.sub("Title",self.name)
      File.open(new_name,"w"){|f| f.write(data)}
    end
  end

  def remove_template
    new_name = Rails.root.join('app','views','guides',"_"+self.file_name+".html.erb")
    if File.exist?(new_name)
      File.delete(new_name)
    end
  end

  def rename_template
    if self.name_changed?
      old_name = I18n.transliterate(self.name_was.downcase.gsub(/\s/,'_'))
      old_file_name = Rails.root.join('app','views','guides',"_"+old_name+".html.erb")
      new_file_name = Rails.root.join('app','views','guides',"_"+self.file_name+".html.erb")
      File.rename(old_file_name,new_file_name)
    end
  end

  def reformat
    name = Rails.root.join("app","views","guides","_"+self.file_name+".html.erb")
    text = File.read(name)
    new_text = text.gsub(/((<div id="main-content">)|(<div id="guide_body">)|(<\/div>))/,"")
    File.open(name,"w"){|file| file.puts new_text}
  end

  # def rename
  #   old_name = Rails.root.join("app","views","guides",self.file_name+".html.erb")
  #   if File.exist?(old_name)
  #    new_name =  Rails.root.join("app","views","guides","_"+self.file_name+".html.erb")
  #    File.rename(old_name,new_name)
  #   end
  # end

  def file_name
    I18n.transliterate(self.name).downcase.gsub(/\s/,'_')
  end

end
