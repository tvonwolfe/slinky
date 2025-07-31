# frozen_string_literal: true

require "logger"
require "forwardable"
require "redis"
require "securerandom"
require "uri"

class Link
  extend Forwardable

  DEFAULT_TTL = 60 * 60 * 24 * 7 # 1 week

  class << self
    def all
      redis.keys("link:*").map do |key|
        params = redis.hgetall(key)
        new(**params.transform_keys(&:to_sym))
      end.sort_by(&:created_at)
    end

    def find(id)
      params = redis.hgetall("link:#{id}")

      new(**params.transform_keys(&:to_sym))
    end

    def create(**params)
      logger.info(name) { "Creating #{name} with params: #{params.to_json}" }
      new_link = new(
        id: SecureRandom.alphanumeric,
        created_at: Time.now.utc,
        **params
      )

      expiration = Time.now.to_i + DEFAULT_TTL
      redis.multi do |multi|
        key = "link:#{new_link.id}"
        multi.hset(key, new_link.as_json)
        multi.expireat(key, expiration, nx: true)
      end

      logger.debug(name) { "Link #{new_link.id} created successfully" }
      new_link
    end

    def delete(id)
      logger.info(name) { "Deleting link with id: #{id}" }
      redis.del("link:#{id}")
    end

    def logger = @logger ||= Logger.new($stdout)

    private

    def redis = @redis ||= Redis.new
  end

  attr_reader :id, :url, :notes, :created_at

  def initialize(url:, notes: nil, id: nil, created_at: nil)
    @id = id
    @url = URI(url)
    @notes = notes || ""
    @created_at = Time.at(created_at.to_i)
  end

  def as_json
    {
      id:,
      url: url.to_s,
      notes:,
      created_at: created_at.to_i
    }.compact
  end
end
