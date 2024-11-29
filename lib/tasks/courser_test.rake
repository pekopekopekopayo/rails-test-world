namespace :courser_test do
  desc "전체 성능 테스트"
  task all_tests: :environment do
    require "benchmark"
    TestModel.delete_all
    100.times do |i|
      array = Array.new(100000) { |j| { id: j + i * 10000 } }
      TestModel.insert_all(array)
    end

    # OFFSET 심플테스트
    offset_simple_time = Benchmark.measure do
      TestModel.offset(100000).limit(1000).to_a
    end
    puts "OFFSET 심플테스트 실행 시간: #{offset_simple_time.real} seconds"

    # COURSER 심플테스트
    courser_simple_time = Benchmark.measure do
      TestModel.where(id: 100000...).limit(1000).to_a
    end
    puts "COURSER 심플테스트 실행 시간: #{courser_simple_time.real} seconds"

    # OFFSET 퍼포먼스테스트
    offset_performance_time = Benchmark.measure do
      TestModel.all.find_each { }
    end
    puts "OFFSET 퍼포먼스테스트 실행 시간: #{offset_performance_time.real} seconds"

    # COURSER 퍼포먼스테스트
    courser_performance_time = Benchmark.measure do
      start_id = 0
      loop do
        test_model = TestModel.where(id: start_id...).limit(1000)
        break if test_model.size != 1000
        start_id = test_model.last.id + 1
      end
    end
    puts "COURSER 퍼포먼스테스트 실행 시간: #{courser_performance_time.real} seconds"

    TestModel.delete_all
  end
end
