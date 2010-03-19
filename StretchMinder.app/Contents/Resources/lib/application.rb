require 'rubygems'
require 'hotcocoa'

# Replace the following code with your own hotcocoa code

class Application
  include HotCocoa
  
  def start
    application :name => "StretchMinder" do |app|
      app.delegate = self
      @queue = Dispatch::Queue.new('org.macruby.stretchminder')
      window(:size => [475, 40], :center => true, :title => "StretchMinder", :view => :nolayout, :style => [:titled, :closable, :miniaturizable]) do |win|
        win.view = layout_view(:mode => :horizontal, :spacing => 5, :layout => {:expand => [:width, :height], :padding => 0, :margin => 0}) do |horiz|
          horiz << label(:text => "Stretch every", :layout => {:align => :center})
          horiz << interval = text_field(:text => "30", :layout => {:start => true})
          horiz << label(:text => "minutes with this message", :layout => {:align => :center})
          horiz << message = text_field(:text => "Stretch Lazy Bones!", :layout => {:start => true})
          horiz << button(:title => 'Start', :layout => {:align => :center}) do |b|
            b.on_action { queue_timer(interval, message) }
          end
        end
        win.will_close { exit }
      end
    end
  end

  def queue_timer(interval, message)
    @queue.async do
      loop do
        sleep interval.to_f * 0.05
        `growlnotify -m "#{message}" StretchMinder`
      end
    end
  end
  
end

Application.new.start