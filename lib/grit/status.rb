module Grit
  class Status
    class StatusFile
      def diff_string
        old = @base.object(self.sha_repo)
        new = @base.object(self.sha_index)
        data_old = old.content.split(/\n/).map! { |e| e.chomp }
        data_new = new.content.split(/\n/).map! { |e| e.chomp }
        diffs = Difference::LCS.diff(data_old, data_new)
        file_length_difference = 0
        lines = 3
        oldhunk = hunk = nil
        output = "--- a/#{self.path}\n+++ b/#{self.path}"
        format = :unified
        diffs.each do |piece|
          begin
            hunk = Difference::LCS::Hunk.new(data_old, data_new, piece, lines, file_length_difference)
            file_length_difference = hunk.file_length_difference
            next unless oldhunk
            if lines > 0 && hunk.overlaps?(oldhunk)
              hunk.unshift(oldhunk)
            else
              output << oldhunk.diff(format)
            end
          ensure
            oldhunk = hunk
            output << "\n"
          end
        end
        output << oldhunk.diff(format)
        output << "\n"
        output
      end
    end
  end
end
