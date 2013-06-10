class String
	def seconds_from_midnight(am_pm)
		time_array = self.split(':')
		hours = time_array[0].to_i
		minutes = time_array[1].to_i
		
		if am_pm == 'AM'
			if hours != 12
				secondsFromHours = hours * 3600
			else
				secondsFromHours = 0
			end
		else
			if hours != 12
				secondsFromHours = 43200 + (hours * 3600)
			else
				secondsFromHours = 43200
			end
		end
		secondsFromMinutes = minutes * 60

		totalSeconds = secondsFromHours + secondsFromMinutes
	end

	def cmp_times(am_pm, other_time, other_am_pm)
		# Returns -1 if self is earlier than other_time, 0 if the times are equal, and 1 if self is later than other_time

		firstTimeSec = self.seconds_from_midnight(am_pm)
		secondTimeSec = other_time.seconds_from_midnight(other_am_pm)

		firstTimeSec.cmp_times(secondTimeSec)
	end
end

class Fixnum
	def to_readable
		hours = (self / 3600).to_i
		minutes = ((self % 3600) / 60).to_i
		
		if minutes < 10
			minutes = "0" + minutes.to_s
		end

		if hours > 12
			hours -= 12
			am_pm = 'PM'
		elsif hours < 12 and hours != 0
			am_pm = 'AM'
		elsif hours == 0
			am_pm = 'AM'
			hours += 12
		else
			am_pm = 'PM'
		end
			
		readableTime = [hours.to_s + ":" + minutes.to_s, am_pm]
	end

	def cmp_times(other_time)
		# Returns -1 if self is earlier than other_time, 0 if the times are equal, and 1 if self is later than other_time

		if self < other_time
			return -1
		elsif self > other_time
			return 1
		else
			return 0
		end
	end
end






