class Lokaci{
    String language = "";

    Lokaci(this.language);

    String getPWDTime(){

        final time = getTimeParts();
        int hour = time['hour'];
        int minute = time['minute'];
        String period = time['period'];

        final timeInWords = getTimeInWords(hour, minute, period);
        return timeInWords;
    }
    
    String getTimeInWords(int hour12, int minute, String period){
        //return '$hour12:$minute $period $language'; // e.g., 2:5 PM
        // STEP 2: Handle special cases and cases for time a matsayin bahushe
        
        if(minute == 0){
        return language == 'en' 
            ? '${_numberToWords(hour12)} o\'clock $period'
            : 'karfe ${_numberToWordsHausa(hour12)} daidai $period'; 
        } else if (minute == 15) {
        return language == 'en'
            ? 'Quarter past ${_numberToWords(hour12)} $period'
            : 'karfe ${_numberToWordsHausa(hour12)} da kwata $period';
        } else if (minute == 30) {
        return language == 'en'
            ? 'Half past ${_numberToWords(hour12)} $period'
            : 'karfe ${_numberToWordsHausa(hour12)} da rabi $period';
        } else if (minute == 45) {
        final int nextHour = hour12 == 12 ? 1 : hour12 + 1;
        return language == 'en'
            ? 'Quarter to ${_numberToWords(nextHour)} $period'
            : 'karfe ${_numberToWordsHausa(nextHour)} saura kwata $period';
        } else if (minute < 30) {
        return language == 'en'
            ? '${_numberToWords(minute)} minute past ${_numberToWords(hour12)} $period'
            : 'karfe ${_numberToWordsHausa(hour12)} da minti ${_numberToWordsHausa(minute)} $period';
        } else {
        final int nextHour = hour12 == 12 ? 1 : hour12 + 1;
        final int minutesTo = 60 - minute;
        return language == 'en'
            ? '${_numberToWords(minutesTo)} minute to ${_numberToWords(nextHour)} $period'
            : 'karfe ${_numberToWordsHausa(nextHour)} saura minti ${_numberToWordsHausa(minutesTo)} $period';
        }
    }


    Map<String, dynamic> getTimeParts() {
    DateTime now = DateTime.now();

    int hour24 = now.hour;
    int hour12 = hour24 % 12;
    int minute = now.minute;
    if (hour12 == 0) hour12 = 12;

    if(language == 'en'){
        return {
        'hour': hour12,
        'minute': now.minute,
        'period': hour24 >= 12 ? 'PM' : 'AM',
        };
    }else{
        if ((hour24 >= 19 && hour24 <= 23) || (hour24 >= 0 && hour24 <= 4)) {
            // 19:00 - 23:59 or 00:00 - 04:29
            if (hour24 == 4 && minute > 29) {
            // 04:30 - 04:59 is actually "asuba"
            return {'hour': hour12, 'minute': now.minute, 'period': 'na asuba' };
            }
            return {'hour': hour12, 'minute': now.minute, 'period': 'na dare' };
        } 
        else if (hour24 == 4 || (hour24 == 5) || (hour24 == 6 && minute <= 29)) {
            // 04:30 - 06:29
            if (hour24 == 4 && minute < 30) {
            return {'hour': hour12, 'minute': now.minute, 'period': 'na dare' }; // 04:00 - 04:29 is still night
            }
            return {'hour': hour12, 'minute': now.minute, 'period': 'na asuba' };
        } 
        else if ((hour24 == 6 && minute >= 30) || (hour24 >= 7 && hour24 <= 11)) {
            // 06:30 - 11:59
            return {'hour': hour12, 'minute': now.minute, 'period': 'na safe' };
        } 
        else if (hour24 == 12 || (hour24 >= 13 && hour24 <= 15) || (hour24 == 15 && minute <= 29)) {
            // 12:00 - 15:29
            return {'hour': hour12, 'minute': now.minute, 'period': 'na rana' };
        } 
        else if ((hour24 == 15 && minute >= 30) || (hour24 >= 16 && hour24 <= 18)) {
            // 15:30 - 18:59
            return {'hour': hour12, 'minute': now.minute, 'period': 'na yamma' };
        } 
        else {
            return {'hour': hour12, 'minute': now.minute, 'period': 'na dare' };
        }
    }
    
    }
    String _numberToWordsHausa(int number) {
        const kidaya = [
        '', 'daya', 'biyu', 'uku', 'hudu', 'biyar', 'shida', 'bakwai',
        'takwas', 'tara', 'goma', 'goma_sha_daya', 'goma_sha_biyu', 'goma_sha_uku',
        'goma_sha_hudu', 'goma_sha_biyar', 'goma_sha_shida', 'goma_sha_bakwai',
        'goma_sha_takwas', 'goma_sha_tara'
        ];
        const goma = [
        '', '', 'ashirin', 'talatin', "arbain", 'hamsin'
        ];
        
        if (number < 20) return kidaya[number];
        if (number < 60) {
        final int gomomi = number ~/ 10;
        final int daidaiku = number % 10;
        if (daidaiku == 0) return goma[gomomi];
        return '${goma[gomomi]} da ${kidaya[daidaiku]}';
        }
        return number.toString();
    }

  // ALGORITHM: _numberToWords() - English
  String _numberToWords(int number) {
    const units = [
      '', 'one', 'two', 'three', 'four', 'five', 'six', 'seven',
      'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen',
      'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen',
      'nineteen'
    ];
    const tens = [
      '', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty',
      'seventy', 'eighty', 'ninety'
    ];
    
    if (number < 20) return units[number];
    if (number < 100) {
      final int tensDigit = number ~/ 10;
      final int unitDigit = number % 10;
      if (unitDigit == 0) return tens[tensDigit];
      return '${tens[tensDigit]} ${units[unitDigit]}';
    }
    return number.toString();
  }

}
