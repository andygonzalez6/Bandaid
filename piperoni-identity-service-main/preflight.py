from models import Genre, User, PersonalGenre, Instrument, PersonalInstrument, UserDetail
from auth.auth_password import get_password_hash
from schemas import CollaborationPreference
# Define some data when database resets

user_list = [
    User(hashed_password=get_password_hash("password"), email="rishabh_poikayil@ucsb.edu"),
    User(hashed_password=get_password_hash("password"), email="b_feng@ucsb.edu"),
    User(hashed_password=get_password_hash("password"), email="aviv@ucsb.edu"),
    User(hashed_password=get_password_hash("password"), email="kya@ucsb.edu"),
    User(hashed_password=get_password_hash("password"), email="andysgonzalez@ucsb.edu"),
    User(hashed_password=get_password_hash("password"), email="demo@ucsb.edu")
]

genre_list = [
    Genre(name="Classical"), 
    Genre(name="Hip Hop"), 
    Genre(name="Rock"), 
    Genre(name="Jazz"), 
    Genre(name="Indie"),
    Genre(name="Metal"),
    Genre(name="Pop"),
    Genre(name="Electronic"),
    Genre(name="Blues"),
    Genre(name="Rap"),
    Genre(name="Punk"),
    Genre(name="Folk"),
    Genre(name="World Music"),
    Genre(name="Gospel"),
    Genre(name="R&B")
]

personal_genre_list = [
    PersonalGenre(user_id=1, genre_id=1),
    PersonalGenre(user_id=1, genre_id=3),
    PersonalGenre(user_id=1, genre_id=5),
    PersonalGenre(user_id=2, genre_id=2),
    PersonalGenre(user_id=2, genre_id=4),
    PersonalGenre(user_id=2, genre_id=6),
    PersonalGenre(user_id=3, genre_id=1),
    PersonalGenre(user_id=3, genre_id=2),
    PersonalGenre(user_id=3, genre_id=3),
    PersonalGenre(user_id=4, genre_id=5),
    PersonalGenre(user_id=4, genre_id=6),
    PersonalGenre(user_id=4, genre_id=7),
    PersonalGenre(user_id=5, genre_id=8),
    PersonalGenre(user_id=5, genre_id=9),
    PersonalGenre(user_id=5, genre_id=10),
]

instrument_list = [
    Instrument(name="Guitar"),
    Instrument(name="Cello"),
    Instrument(name="Banjo"),
    Instrument(name="Bass"),
    Instrument(name="Harp"),
    Instrument(name="Saxophone"),
    Instrument(name="Clarinet"),
    Instrument(name="Electric Keyboard"),
    Instrument(name="Glass Harmonica"),
    Instrument(name="Accordion"),
    Instrument(name="Piano"),
    Instrument(name="Drum"),
    Instrument(name="Tube"),
]

personal_instrument_list = [
    PersonalInstrument(user_id=1, instrument_id=3),
    PersonalInstrument(user_id=1, instrument_id=5),
    PersonalInstrument(user_id=1, instrument_id=7),
    PersonalInstrument(user_id=2, instrument_id=1),
    PersonalInstrument(user_id=2, instrument_id=2),
    PersonalInstrument(user_id=2, instrument_id=6),
    PersonalInstrument(user_id=3, instrument_id=3),
    PersonalInstrument(user_id=3, instrument_id=4),
    PersonalInstrument(user_id=3, instrument_id=7),
    PersonalInstrument(user_id=4, instrument_id=1),
    PersonalInstrument(user_id=4, instrument_id=4),
    PersonalInstrument(user_id=4, instrument_id=5),
    PersonalInstrument(user_id=5, instrument_id=2),
    PersonalInstrument(user_id=5, instrument_id=3),
    PersonalInstrument(user_id=5, instrument_id=5)
]


personal_detail_list = [
    UserDetail(user_id=1, title="Music Producer", description="Hello, my name is Rishabh. I am a college student at UCSB.", preference=CollaborationPreference.no_preference, address="Santa Barbara, CA 93106", first_name="Rishabh", last_name="Poikayil", followers=list(), following=list()),
    UserDetail(user_id=2, title="Guitarist", description="Hello, my name is Leon. I am a college student at UCSB.", preference=CollaborationPreference.in_person, address="Santa Barbara, CA 93106", first_name="Leon", last_name="Feng", followers=list(), following=list()),
    UserDetail(user_id=3, title="Pianist", description="Hello, my name is Aviv. I am a college student at UCSB.", preference=CollaborationPreference.online, address="Santa Barbara, CA 93106",  first_name="Aviv", last_name="Samet", followers=list(), following=list()),
    UserDetail(user_id=4, title="Pianist", description="Hello, my name is Kirill. I am a college student at UCSB.", preference=CollaborationPreference.in_person, address="Santa Barbara, CA 93106", first_name="Kirill", last_name="Aristarkhov", followers=list(), following=list()),
    UserDetail(user_id=5, title="Music Producer", description="Hello, my name is Andy. I am a college student at UCSB.", preference=CollaborationPreference.in_person, address="Santa Barbara, CA 93106", first_name="Andy", last_name="Gonzalez", followers=list(), following=list())
]