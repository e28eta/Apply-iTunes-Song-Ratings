-- Apply iTunes Song Ratings 2.0
-- By Trevor Harmon <email unknown>
-- License: GPL - http://www.gnu.org/copyleft/gpl.html

-- Updated to copy play & skip counts and dates by Dan Jackson

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
		
		(* djackson: I'm sure there's a more elegant way to do this, but I was getting 
		 errors when a field was blank (empty string).
		 Therefore, I check the length of the string, and then either convert it to a
		 number/date as appropriate, or skip the field. *)
		set rating_field to item 26 of music_fields
		if length of rating_field > 0 then
			set the_rating to (rating_field as number)
		else
			set the_rating to 0
		end if
		
		set play_field to item 22 of music_fields
		if length of play_field > 0 then
			set the_plays to (play_field as number)
		else
			set the_plays to 0
		end if
		
		set last_played_field to item 23 of music_fields
		if length of last_played_field > 0 then
			set last_played to (date last_played_field)
		end if
		
		set skips_field to item 24 of music_fields
		if length of skips_field > 0 then
			set the_skips to (skips_field as number)
		else
			set the_skips to 0
		end if
		
		set last_skipped_field to item 25 of music_fields
		if length of last_skipped_field > 0 then
			set last_skipped to (date last_skipped_field)
		end if
		
		
		tell application "iTunes"
			set the_tracks to (file tracks of library playlist 1 whose name is the_name and artist is the_artist and album is the_album)
			repeat with the_track in the_tracks
				-- djackson: I don't understand why casting to integer seems to be necessary here
				set the rating of the_track to (the_rating as integer)
				
				set the played count of the_track to (the_plays as integer)
				if length of last_played_field > 0 then
					set the played date of the_track to (last_played as date)
				end if
				
				set the skipped count of the_track to (the_skips as integer)
				if length of last_skipped_field > 0 then
					set the skipped date of the_track to (last_skipped as date)
				end if
			end repeat
		end tell
	end if
end repeat
