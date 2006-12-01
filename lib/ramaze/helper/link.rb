module Ramaze

  # LinkHelper is included into the Template::Ramaze by default
  #
  # this helper tries to get along without any major magic, the only 'magic'
  # thing is that it looks up controller-paths if you pass it a controller
  # the text shown is always the last segmet of the finished link from split('/')
  #
  # usage is pretty much shown in test/tc_helper
  # however, to give you some idea of how it actually works, some examples:
  #
  # link MainController, :foo                 #=> '<a href="/foo">foo</a>'
  # link MinorController, :foo                #=> '<a href="/minor/foo">foo</a>'
  # link MinorController, :foo, :bar          #=> '<a href="/minor/foo/bar">bar</a>'
  # link MainController, :foo, :raw => true   #=> '/foo'
  #
  # link_raw MainController, :foo             #=> '/foo'
  # link_raw MinorController, :foo            #=> '/minor/foo'
  # link_raw MinorController, :foo, :bar      #=> '/minor/foo/bar'
  #
  # TODO:
  #   - handling of no passed parameters
  #   - setting of a custom link-title, possibly images as well
  #   - setting of id or class
  #   - taking advantae of Gestalt to build links
  #   - lots of other minor niceties, for the moment i'm only concerned to keep
  #     it as simple as possible
  #

  module LinkHelper

    # Usage:
    #   link MainController, :foo                 #=> '<a href="/foo">foo</a>'
    #   link MinorController, :foo                #=> '<a href="/minor/foo">foo</a>'
    #   link MinorController, :foo, :bar          #=> '<a href="/minor/foo/bar">bar</a>'
    #   link MainController, :foo, :raw => true   #=> '/foo'

    def link *to
      hash = to.last.is_a?(Hash) ? to.pop : {}

      to = to.flatten

      to.map! do |t|
        Global.mapping.invert[t] || t
      end

      link = to.join('/').squeeze('/')
      title = link.split('/').last

      if hash[:raw]
        link
      else
        %{<a href="#{link}">#{title}</a>}
      end
    end

    # Usage:
    #   link_raw MainController, :foo             #=> '/foo'
    #   link_raw MinorController, :foo            #=> '/minor/foo'
    #   link_raw MinorController, :foo, :bar      #=> '/minor/foo/bar'

    def link_raw *to
      if to.last.is_a?(Hash)
        to.last[:raw] = true
      else
        to << {:raw => true}
      end

      link(*to)
    end
  end
end
