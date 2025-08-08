# frozen_string_literal: true

require "sinatra"

require_relative "environment"
require_relative "link"

def render_link(link)
  <<-HTML
    <turbo-frame id="link_#{link.id}">
      <li>
        <div class="link">
          <a target="_blank" rel="noopener noreferrer" href="#{link.url}">#{link.url}</a>
          <div class="link-tools">
            <p>Added <time datetime="#{link.created_at.utc.iso8601}">#{link.created_at}</time></p>
          </div>
        </div>
      </li>
    </turbo-frame>
  HTML
end

def render_new_url_form
  <<-HTML
    <turbo-frame id="new_url_form">
      <form action="/links" method="post" class="new-url-form">
        <input
          id="new_url_input"
          class="url-input"
          type="url"
          name="url"
          placeholder="New Link..."
          autocomplete="off"
          required="true"
        />
        <button type="submit" class="submit-btn">Save</button>
      </form>
    </turbo-frame>
  HTML
end

get "/" do
  <<-HTML
    <!DOCTYPE html>
    <html>
      <head>
        <title>Slinky</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script type="module" src="https://cdn.jsdelivr.net/npm/@hotwired/turbo@latest/dist/turbo.es2017-esm.min.js"></script>
        <link rel="stylesheet" href="/stylesheets/application.css">
      </head>
      <body>
        <div class="app">
          <div class="header">
            <a href="/">
              <h1 class="header">slinky</h1>
            </a>
          </div>
          <div class="links-list-container">
            <ol id="links-list">
              <turbo-frame id="links">
                #{Link.all.map(&method(:render_link)).join("\n")}
              </turbo-frame>
            </ol>
          </div>
          #{render_new_url_form}
        </div>
      </body>
    </html>
  HTML
end

post "/links" do
  new_link = Link.create(url: params[:url])

  content_type "text/vnd.turbo-stream.html"
  status 201

  <<-HTML
    <turbo-stream action="append" target="links">
     <template>
        #{render_link(new_link)}
      </template>
    </turbo-stream>

    <turbo-stream action="replace" target="new_url_form">
      <template>
        #{render_new_url_form}
      </template>
    </turbo-stream>
  HTML
end
