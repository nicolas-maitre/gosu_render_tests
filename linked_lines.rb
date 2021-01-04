require 'gosu'
class LinkedLines < Gosu::Window
    CIRCLE_RADIUS = 200
    def initialize
        @points = []
        @selected_point = nil
        super 1280, 720

        #gen circle
        update_circle(10)
    end
    def update
        @points << {x: mouse_x, y: mouse_y} if button_down? Gosu::KB_SPACE
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
        if(button == Gosu::KB_R)
            @points.clear
            @circle_node_counts = 10
            return
        end
        if(button == Gosu::KB_UP)
            update_circle(@circle_node_counts + 1)
            return
        end
        if(button == Gosu::KB_DOWN)
            update_circle(@circle_node_counts - 1)
            return
        end
        return if [Gosu::MS_RIGHT, Gosu::KB_SPACE].include? button
        @points << {x: mouse_x, y: mouse_y}
    end
    def update_circle(count)
        @circle_node_counts = count
        spacing = 2 * Math::PI / @circle_node_counts
        @points = 0.upto(@circle_node_counts - 1).map do |index|
            angle = spacing * index
            x_pos = (Math.sin(angle) + 1)*CIRCLE_RADIUS
            y_pos = (Math.cos(angle) + 1)*CIRCLE_RADIUS
            {x: x_pos + 200, y: y_pos + 100}
        end
    end
end
LinkedLines.new.show