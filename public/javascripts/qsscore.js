String.prototype.score = function(abbreviation,offset) {
  offset = offset || 0
 
  if(abbreviation.length == 0) return 0.9
  if(abbreviation.length > this.length) return 0.0

  for (var i = abbreviation.length; i > 0; i--) {
   var sub_abbreviation = abbreviation.substring(0,i)
   var index = this.indexOf(sub_abbreviation)

 
   if(index < 0) continue;
   if(index + abbreviation.length > this.length + offset) continue;
 
   var next_string       = this.substring(index+sub_abbreviation.length)
   var next_abbreviation = null
 
   if(i >= abbreviation.length)
     next_abbreviation = ''
   else
     next_abbreviation = abbreviation.substring(i)
 
   var remaining_score   = next_string.score(next_abbreviation,offset+index)
 
   if (remaining_score > 0) {
     // the score is set to the difference between remaining and start
     var score = this.length-next_string.length;
   
   
     // if (matchedRange.location > searchRange.location) { //if some letters were skipped
     if(index != 0) {
       var j = 0;
     
       var c = this.charCodeAt(index-1)
       if(c==32 || c == 9) {
         for(var j=(index-2); j >= 0; j--) {
           c = this.charCodeAt(j)
           score -= ((c == 32 || c == 9) ? 1 : 0.15)
         }

         // XXX maybe not port this heuristic
       // 
       //          } else if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[self characterAtIndex:matchedRange.location]]) {
       //            for (j = matchedRange.location-1; j >= (int) searchRange.location; j--) {
       //              if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[self characterAtIndex:j]])
       //                score--;
       //              else
       //                score -= 0.15;
       //            }
       } else {
         score -= index
       }

     }
   

     score += remaining_score * next_string.length
     score /= this.length;
     return score
   }
 
  }
 
  return 0.0
}