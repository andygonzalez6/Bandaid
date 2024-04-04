class CurrentUserService:
    def __init__(self, db_handler) -> None:
        super().__init__()
        self.db_handler = db_handler
    
    def fetch_current_user_personal_genres(self, user_id: int):
        all_genres = self.db_handler.get_all_music_genres()
        personal_genres = self.db_handler.get_current_user_genres(user_id)

        result = []
        selected_genres = set()

        for personal_genre in personal_genres:
            selected_genres.add(personal_genre.name)
        
        for genres in all_genres:
            genres_dict = genres.__dict__
            is_selected = False

            if genres.name in selected_genres:
                is_selected = True
        
            result.append({
                **genres_dict,
                "selected": is_selected
            })

        return result
    
    def fetch_current_user_personal_instruments(self, user_id: int):
        all_instruments = self.db_handler.get_all_instruments()
        personal_instruments = self.db_handler.get_current_user_instruments(user_id)

        result = []
        selected_instruments = set()

        for personal_instrument in personal_instruments:
            selected_instruments.add(personal_instrument.name)

        for instrument in all_instruments:
            instrument_dict = instrument.__dict__
            is_selected = False

            if instrument.name in selected_instruments:
                is_selected = True
            
            result.append({
                **instrument_dict,
                "selected": is_selected
            })

        return result
    