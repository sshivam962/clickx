module Arel
  module Nodes
    class Contains < Arel::Nodes::Binary
      def operator
        :>>
      end
    end

    class ContainsArray < Arel::Nodes::Binary
      def operator
        :"@>"
      end
    end
  end

  module Predications
    def contains(other)
      Nodes::Contains.new self, Nodes.build_quoted(other, self)
    end
  end

  module Visitors
    class PostgreSQL
      private

      def visit_Arel_Nodes_Contains(o, collector)
        left_column = o.left.relation.name.classify.constantize.columns.find do |col|
          col.name == o.left.name.to_s || col.name == o.left.relation.name.to_s
        end

        if left_column && (left_column.type == :hstore || (left_column.respond_to?(:array) && left_column.array))
          infix_value o, collector, ' @> '
        else
          infix_value o, collector, ' >> '
        end
      end

      def visit_Arel_Nodes_ContainsArray(o, collector)
        infix_value o, collector, ' @> '
      end
    end
  end
end
