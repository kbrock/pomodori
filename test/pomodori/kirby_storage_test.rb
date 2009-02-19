require File.dirname(__FILE__) + '/../test_helper'
require 'thirdparties/kirbybase'
require 'pomodori/kirby_storage'
require 'pomodori/pomodoro'

class KirbyStorageTest < Test::Unit::TestCase
  
  def setup
    @path = File.dirname(__FILE__) + "/../work"
    create_db(@path)
    @kirby_storage = KirbyStorage.new(@path)
    Time.stubs(:now).returns(Time.local(2009, "feb", 18, "5", "25"))
  end
  
  def test_retrieves_table_for_instances_or_class
    assert_not_nil(@kirby_storage.send(:table_for, Pomodoro.new))
    assert_not_nil(@kirby_storage.send(:table_for, Pomodoro))
  end
  
  def test_creates_a_record
    @kirby_storage.save(Pomodoro.new(:text => "done!"))
    assert_equal(1, @kirby_storage.find_all(Pomodoro).size)
  end
  
  def test_returns_all_pomodori
    bulk_import_test_data
    assert_equal(32, @kirby_storage.find_all(Pomodoro).size)
  end
  
  def test_returns_all_pomodoros_by_date
    bulk_import_test_data
    date = Time.local(2009, "feb", 16, "5", "25")
    assert_equal(5, @kirby_storage.find_all_by_date(Pomodoro, date).size)
  end
  
  def test_returns_all_yesterdays_pomodoros
    bulk_import_test_data
    assert_equal(10, @kirby_storage.yesterday_pomodoros.size)
  end
  
  def test_returns_all_todays_pomodoros
    bulk_import_test_data
    assert_equal(6, @kirby_storage.today_pomodoros.size)
  end
  
  def teardown
    wipe_dir(@path)
  end
  
  private
    
    def create_db(path)
      db = KirbyBase.new(:local, nil, nil, path)
      db.drop_table(:pomodoro) if db.table_exists?(:pomodoro)
      pomodoro_tbl = db.create_table(:pomodoro, :text, :String, :timestamp, :Time) { |obj| obj.encrypt = false }
    end
    
    def bulk_import_test_data
      open("#{@path}/pomodoro.tbl", 'w') do |output|
        open(File.dirname(__FILE__) + '/pomodoro_test_data.txt') do |input|
          input.readlines.each {|line| output.write(line)}
        end
      end
    end

end