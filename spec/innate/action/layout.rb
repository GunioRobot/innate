#          Copyright (c) 2009 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'spec/helper'

Innate.options.app.root = File.dirname(__FILE__)

class SpecActionLayoutMethod
  include Innate::Node

  map '/from_method'
  layout 'method_layout'

  def method_layout
    "<pre><%= @content %></pre>"
  end

  def index
    'Method Layout'
  end

  def foo
    "bar"
  end
end

class SpecActionLayoutFile
  include Innate::Node

  map '/from_file'
  layout 'file_layout'

  def index
    "File Layout"
  end
end

class SpecActionLayoutSpecific
  include Innate::Node

  map '/specific'
  layout('file_layout'){|name, wish| name == 'index' }

  def index
    'Specific Layout'
  end

  def without
    "Without wrapper"
  end
end

class SpecActionLayoutDeny
  include Innate::Node

  map '/deny'
  layout('file_layout'){|name, wish| name != 'without' }

  def index
    "Deny Layout"
  end

  def without
    "Without wrapper"
  end
end

class SpecActionLayoutMulti
  include Innate::Node

  map '/multi'
  layout('file_layout'){|name, wish| name =~ /index|second/ }

  def index
    "Multi Layout Index"
  end

  def second
    "Multi Layout Second"
  end

  def without
    "Without wrapper"
  end
end

describe 'Innate::Action#layout' do
  behaves_like :mock

  it 'uses a layout method' do
    get('/from_method').body.should == '<pre>Method Layout</pre>'
    get('/from_method/foo').body.should == '<pre>bar</pre>'
  end

  it 'uses a layout file' do
    get('/from_file').body.strip.should == '<p>File Layout</p>'
  end

  it 'denies layout to some actions' do
    get('/deny').body.strip.should == '<p>Deny Layout</p>'
    get('/deny/without').body.strip.should == 'Without wrapper'
  end

  it 'uses layout only for specific action' do
    get('/specific').body.strip.should == '<p>Specific Layout</p>'
    get('/specific/without').body.strip.should == 'Without wrapper'
  end

  it 'uses layout only for specific actions' do
    get('/multi').body.strip.should == '<p>Multi Layout Index</p>'
    get('/multi/second').body.strip.should == '<p>Multi Layout Second</p>'
    get('/multi/without').body.strip.should == 'Without wrapper'
  end
end