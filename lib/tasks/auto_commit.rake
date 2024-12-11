namespace :auto_commit_test do
  desc "전체 성능 테스트"
  task all_tests: :environment do
    require "benchmark"
    TestModel.delete_all

    create_time = Benchmark.measure do
      100000.times do |_|
        TestModel.create(number: 0)
      end
    end
    puts "auto_commit의 생성 시간: #{create_time.real} seconds"

    create_time = Benchmark.measure do
      ActiveRecord::Base.transaction do
        100000.times do |_|
          TestModel.create(number: 0)
        end
      end
    end

    puts "트랜잭션의 생성 시간: #{create_time.real} seconds"

    create_time = Benchmark.measure do
      arr = []
      100000.times do |_|
        arr << { number: 0 }
      end

      TestModel.insert_all(arr)
    end

    puts "insert_all의 생성 시간: #{create_time.real} seconds"
  end
end
