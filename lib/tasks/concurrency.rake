namespace :concurrency do
  desc "5개의 스레드를 동시에 실행하여 성능 테스트"
  task not_bloking: :environment do
    TestModel.delete_all
    test_model = TestModel.create(number: 0)  # 초기 값 0

    # ThreadPoolExecutor를 사용하여 5개의 스레드를 동시에 실행
    pool = Concurrent::ThreadPoolExecutor.new

    # 5개의 스레드를 동시에 실행
    5.times do
      pool.post do
        10.times do
          sleep(1)  # 처리 시간 시뮬레이션
          test_model.number += 1
          test_model.save
        end
      end
    end

    pool.shutdown
    pool.wait_for_termination  # 모든 스레드가 완료될 때까지 기다림

    pp TestModel.first.number  # 최종 결과 출력
  end

  desc "Redis를 사용하여 5개의 스레드를 동시에 실행하여 동시성 테스트"
  task redis_blocking: :environment do
    TestModel.delete_all
    test_model = TestModel.create(number: 0)  # 초기 값 0
    redis = Redis.new(url: "redis://redis:6379/0")

    # ThreadPoolExecutor를 사용하여 5개의 스레드를 동시에 실행
    pool = Concurrent::ThreadPoolExecutor.new

    # 5개의 스레드를 동시에 실행
    5.times do
      pool.post do
        10.times do
          sleep(1)  # 처리 시간 시뮬레이션
          redis.incr("test_model_number:#{test_model.id}:number")
        end
      end
    end

    pool.shutdown
    pool.wait_for_termination  # 모든 스레드가 완료될 때까지 기다림

    pp redis.get("test_model_number:#{test_model.id}:number")  # 최종 결과 출력
  end

  desc "DB Lock 사용하여 5개의 스레드를 동시에 실행하여 동시성 테스트"
  task db_blocking: :environment do
    TestModel.delete_all
    test_model = TestModel.create(number: 0)
    pool = Concurrent::ThreadPoolExecutor.new
    5.times do
      pool.post do
        test_model.with_lock do
          10.times do
            sleep(1)
            test_model.number += 1
            pp test_model.number
            test_model.save!
          end
        end
      end
    end

    pool.shutdown
    pool.wait_for_termination  # 모든 스레드가 완료될 때까지 기다림

    pp TestModel.first.number  # 최종 결과 출력
  end
end
