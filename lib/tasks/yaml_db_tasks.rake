namespace :db do
  desc "Dump schema and data to db/schema.rb and db/data.yml"
  task(:dump => [ "db:schema:dump", "db:data:dump" ])

  desc "Load schema and data from db/schema.rb and db/data.yml"
  task(:load => [ "db:schema:load", "db:data:load" ])

  namespace :data do
    def db_dump_data_file (extension = "yml")
      "#{dump_dir}/data.#{extension}"
    end

    def dump_dir(dir = "")
      "#{Rails.root}/#{dir}"
    end

    desc "Dump contents of database to db/data.extension (defaults to yaml)"
    task :dump => :environment do
      format_class = ENV['class'] || "YamlDb::Helper"
      helper = format_class.constantize
      SerializationHelper::Base.new(helper).dump db_dump_data_file helper.extension
    end

    desc "Dump contents of database to db/backup/tablename.extension (defaults to yaml)"
    task :dump_dir do |t|
      dir = ENV['DIR'] || "db/backup"
      format_class = ENV['class'] || "YamlDb::Helper"
      SerializationHelper::Base.new(format_class.constantize).dump_to_dir dump_dir("/#{dir}")
    end

    desc "Load contents of db/data.extension (defaults to yaml) into database"
    task :load => :environment do
      format_class = ENV['class'] || "YamlDb::Helper"
      helper = format_class.constantize
      SerializationHelper::Base.new(helper).load(db_dump_data_file helper.extension)
    end

    desc "Load contents of db/backup into database"
    task :load_dir do |t|
      dir = ENV['DIR'] || "db/backup"
      format_class = ENV['class'] || "YamlDb::Helper"
      SerializationHelper::Base.new(format_class.constantize).load_from_dir dump_dir("/#{dir}")
    end
  end
end
