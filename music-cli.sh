MUSIC_CLI_DIR=~/.music-cli
ACTIVE_PLAYLIST_FILE=$MUSIC_CLI_DIR/active_playlist
bold=`tput bold`
normal=`tput sgr0`
OP=$1
if [ ! -d $MUSIC_CLI_DIR ]; then
	mkdir $MUSIC_CLI_DIR
	echo "" > $ACTIVE_PLAYLIST_FILE
fi
read ACTIVE_PLAYLIST < $ACTIVE_PLAYLIST_FILE

if [ -n $OP ]; then
	if [ $OP = "add" ]; then
		if [ -z $ACTIVE_PLAYLIST ]; then
			echo "Error: No active playlist. Please select a playlist"
		fi
		SONG_NAME=$2
		ARTIST_NAME=$3
		YOUTUBE_URL=$4
		FILENAME=`ls -1 $MUSIC_CLI_DIR/$ACTIVE_PLAYLIST | wc -l`.wav
		FILEPATH=$MUSIC_CLI_DIR/$ACTIVE_PLAYLIST/$FILENAME
		youtube-dl --extract-audio --audio-format wav -o $FILEPATH $YOUTUBE_URL 
		printf "${SONG_NAME}\n${ARTIST_NAME}\n${FILENAME}\n" >> $MUSIC_CLI_DIR/$ACTIVE_PLAYLIST/playlist_data
	elif [ $OP = "list" ]; then
		FILES=`ls -1 $MUSIC_CLI_DIR`
		while read -r FILE; do
			if [ $FILE != "active_playlist" ]; then
				if [ $FILE == $ACTIVE_PLAYLIST ]; then
					echo $bold$FILE$normal
				else
					echo $FILE
				fi
			fi
		done <<< "$FILES"
	elif [ $OP = "active" ]; then
		if [ -z $2 ]; then
			if [ -z $ACTIVE_PLAYLIST ]; then
				echo "No active playlist"
			else
				echo $ACTIVE_PLAYLIST
			fi
		else
			echo $2 > $ACTIVE_PLAYLIST_FILE
		fi
	elif [ $OP = "new" ]; then
		PLAYLIST_NAME=$2
		mkdir $MUSIC_CLI_DIR/$PLAYLIST_NAME
		echo -n > $MUSIC_CLI_DIR/$PLAYLIST_NAME/playlist_data
	elif [ $OP = "play" ]; then
		while read -r SONG_FILE; do
			if [[ $SONG_FILE =~ .*?\.wav$ ]]; then
				SONG_FILE_PATH=$MUSIC_CLI_DIR/$ACTIVE_PLAYLIST/$SONG_FILE
				mplayer $SONG_FILE_PATH > /dev/null
			else
				echo $SONG_FILE
			fi
		done < $MUSIC_CLI_DIR/$ACTIVE_PLAYLIST/playlist_data
	fi
fi

