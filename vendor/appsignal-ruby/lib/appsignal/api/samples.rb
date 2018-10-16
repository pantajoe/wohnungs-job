module Appsignal
  class API::Samples < Endpoint
    def samples(action_id: nil, exception: nil, since: nil, before: nil, limit: nil)
      params = {}
      replacements = [['#', '-hash-'], ['.', '-dot-'], ['/', '-slash-']]
      params = params.merge(since: since.to_time.getutc.to_i.to_s) if since
      params = params.merge(before: since.to_time.getutc.to_i.to_s) if before
      params = params.merge(limit: limit.to_s) if limit
      if action_id
        replacements.each do |replacement|
          action_id.gsub!(replacement[0], replacement[1])
        end
        params = params.merge(action_id: action_id)
      end
      params = params.merge(exception: exception) if exception

      http.
        get("/samples.json", params: params)[:log_entries].
      map {|sample| Sample.build(sample) }
    end

    def performances(action_id: nil, exception: nil, since: nil, before: nil, limit: nil)
      params = {}
      replacements = [['#', '-hash-'], ['.', '-dot-'], ['/', '-slash-']]
      params = params.merge(since: since.to_time.getutc.to_i.to_s) if since
      params = params.merge(before: since.to_time.getutc.to_i.to_s) if before
      params = params.merge(limit: limit.to_s) if limit
      if action_id
        replacements.each do |replacement|
          action_id.gsub!(replacement[0], replacement[1])
        end
        params = params.merge(action_id: action_id)
      end
      params = params.merge(exception: exception) if exception

      http.
        get("/samples/performances.json", params: params)[:log_entries].
      map {|sample| Sample.build(data) }
    end

    def errors(action_id: nil, exception: nil, since: nil, before: nil, limit: nil)
      params = {}
      replacements = [['#', '-hash-'], ['.', '-dot-'], ['/', '-slash-']]
      params = params.merge(since: since.to_time.getutc.to_i.to_s) if since
      params = params.merge(before: since.to_time.getutc.to_i.to_s) if before
      params = params.merge(limit: limit.to_s) if limit
      if action_id
        replacements.each do |replacement|
          action_id.gsub!(replacement[0], replacement[1])
        end
        params = params.merge(action_id: action_id)
      end
      params = params.merge(exception: exception) if exception

      http.
        get("/samples/errors.json", params: params)[:log_entries].
      map {|sample| Sample.build(data) }
    end

    def show(id: nil)
      if id
        body = http.
         get("/samples/#{id}.json", params: {id: id})
        if body[:is_exception]
          ErrorSample.build(body)
        else
          SlowSample.build(body)
        end
      end
    end
  end
end
