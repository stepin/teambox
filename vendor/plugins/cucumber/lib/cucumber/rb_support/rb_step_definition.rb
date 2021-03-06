require 'cucumber/step_match'
require 'cucumber/core_ext/string'
require 'cucumber/core_ext/proc'
require 'cucumber/rb_support/regexp_argument_matcher'

module Cucumber
  module RbSupport
    # A Ruby Step Definition holds a Regexp and a Proc, and is created
    # by calling <tt>Given</tt>, <tt>When</tt> or <tt>Then</tt>
    # in the <tt>step_definitions</tt> ruby files. See also RbDsl.
    #
    # Example:
    #
    #   Given /I have (\d+) cucumbers in my belly/ do
    #     # some code here
    #   end
    #
    class RbStepDefinition

      class MissingProc < StandardError
        def message
          "Step definitions must always have a proc"
        end
      end

      def initialize(rb_language, regexp, proc)
        raise MissingProc if proc.nil?
        if String === regexp
          p = Regexp.escape(regexp)
          p = p.gsub(/\\\$\w+/, '(.*)') # Replace $var with (.*)
          regexp = Regexp.new("^#{p}$") 
        end
        @rb_language, @regexp, @proc = rb_language, regexp, proc
        @rb_language.available_step_definition(regexp_source, file_colon_line)
      end

      def regexp_source
        @regexp.inspect
      end

      def ==(step_definition)
        regexp_source == step_definition.regexp_source
      end

      def arguments_from(step_name)
        args = RegexpArgumentMatcher.arguments_from(@regexp, step_name)
        @rb_language.invoked_step_definition(regexp_source, file_colon_line) if args
        args
      end

      def invoke(args)
        args = args.map{|arg| Ast::PyString === arg ? arg.to_s : arg}
        begin
          args = @rb_language.execute_transforms(args)
          @rb_language.current_world.cucumber_instance_exec(true, regexp_source, *args, &@proc)
        rescue Cucumber::ArityMismatchError => e
          e.backtrace.unshift(self.backtrace_line)
          raise e
        end
      end

      def file_colon_line
        @proc.file_colon_line
      end
    
      def file
        @file ||= file_colon_line.split(':')[0]
      end
    end
  end
end
