require 'gosu'
class LinkedLines < Gosu::Window
    def initialize
        @points = []
        @selected_point = nil
        @autorotate = false
        super 1920, 1080, fullscreen: true

        #gen circle
        update_circle(10, 200)
    end
    def update
        @points << {x: mouse_x, y: mouse_y} if button_down? Gosu::KB_SPACE
        update_circle if @autorotate
    end
    def draw
        those_points = button_down?(Gosu::MS_RIGHT) ? @points + [{x:mouse_x, y:mouse_y}] : @points
        those_points.each_with_index do |first_point, first_index|
            first_index.upto(those_points.length - 1) do |second_index|
                second_point = those_points[second_index]
                draw_line(first_point[:x], first_point[:y], Gosu::Color::rgba(255,255,255,64), second_point[:x], second_point[:y], Gosu::Color::rgba(255,255,255,64))
            end
        end
        those_points.each do |point|
            draw_rect(point[:x] - 2, point[:y] - 2, 4, 4, Gosu::Color::BLUE)
        end
        those_points.each_with_index do |point, point_index|
            previous_point = those_points[point_index - 1]
            draw_line(point[:x], point[:y], Gosu::Color::RED, previous_point[:x], previous_point[:y], Gosu::Color::RED)
        end
    end
    def button_down button
        exit if button == Gosu::KB_ESCAPE
        if(button == Gosu::KB_P)
            @autorotate^=true
            return
        end
        if(button == Gosu::KB_R)
            @points.clear
            @circle_node_counts = 10
            return
        end
        if(button == Gosu::KB_UP)
            update_circle(@circle_node_counts+1)
            return
        end
        if(button == Gosu::KB_DOWN)
            update_circle(@circle_node_counts-1)
            return
        end
        return if [Gosu::MS_RIGHT, Gosu::KB_SPACE].include? button
        @points << {x: mouse_x, y: mouse_y}
    end
    H_SCALE_TIME = 0.8
    V_SCALE_TIME = 0.9
    def update_circle(count=@circle_node_counts, radius=@circle_radius)
        time = @autorotate ? Time.now.to_f : 0
        @circle_node_counts = count
        @circle_radius = radius
        spacing = 2 * Math::PI / @circle_node_counts
        @points = 0.upto(@circle_node_counts - 1).map do |index|
            angle = spacing * index + time
            x_pos = (Math.sin(angle) + 1)*@circle_radius*(Math.sin(time / H_SCALE_TIME) + 1.5)
            y_pos = (Math.cos(angle) + 1)*@circle_radius*(Math.sin(time / V_SCALE_TIME) + 1.5)
            {x: x_pos + 200, y: y_pos + 100}
        end
    end
end
LinkedLines.new.show