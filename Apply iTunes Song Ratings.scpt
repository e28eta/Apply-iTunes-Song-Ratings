-- Apply iTunes Song Ratings 1.0
-- By Trevor Harmon <email available in source download>
-- License: GPL - http://www.gnu.org/copyleft/gpl.html

(*
This script takes as input a Music.txt file created with iTunes' File > Export command. It then applies the song ratings found in this file to the same songs in the current iTunes library. The song name, artist, and album must match; otherwise, the rating will not be affected. If they do match, the current rating will be replaced.

IMPORTANT: Before running this script, the Music.txt file must be encoded as UTF-8. To do so, simply open Music.txt in TextEdit (or a similar editor) and re-save the file with UTF-8 encoding.
*)

set the_file to choose file
set music_lines to read the_file using delimiter {return}

display dialog "This script may take a very long time to run, depending on the size of your iTunes library. (Processing a 2000-song library required approximately 20 minutes on a 2.5 GHz MacBook Pro.)" & return & return & "Do you still want to continue?"

-- Split the line at tab stops
set text item delimiters to ASCII character 9

-- Start at 2 instead of 1 to skip the header line
repeat with i from 2 to count music_lines
  set music_line to item i of music_lines
  set music_fields to every text item of music_line
  if length of music_fields is 27 then
    set the_name to item 1 of music_fields
    set the_artist to item 2 of music_fields
    set the_album to item 4 of music_fields
    set the_rating to item 26 of music_fields
    tell application "iTunes"
      set the_tracks to (file tracks of library playlist 1 whose name is the_name and artist is the_artist and album is the_album)
      repeat with the_track in the_tracks
        set the rating of the_track to the_rating
      end repeat
    end tell
  end if
end repeat
