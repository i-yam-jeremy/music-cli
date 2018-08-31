MUSIC_CLI_DIR=~/.music-cli
ACTIVE_PLAYLIST_FILE=$MUSIC_CLI_DIR/active_playlist
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
		FILENAME=$SONG_NAME-$ARTIST_NAME.mp3
		FILEPATH=$MUSIC_CLI_DIR/$ACTIVE_PLAYLIST/$FILENAME
		youtube-dl --extract-audio --audio-format mp3 -o $FILEPATH $YOUTUBE_URL
		echo $FILENAME >> $MUSIC_CLI_DIR/$ACTIVE_PLAYLIST/playlist_data
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
	elif [ $OP = " " ]; then
		echo "Test"
	fi

fi

