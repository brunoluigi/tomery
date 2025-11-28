# frozen_string_literal: true

class EnablePgvector < ActiveRecord::Migration[8.1]
  def change
    # Enable the pgvector extension for vector similarity search
    enable_extension "vector"
  end
end
