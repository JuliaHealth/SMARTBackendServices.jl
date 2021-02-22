function seconds_since_the_epoch_utc(zoned_date_time::TimeZones.ZonedDateTime)
    zoned_date_time_utc = TimeZones.astimezone(
        zoned_date_time,
        TimeZones.tz"UTC",
    )
    float_number_of_seconds_since_the_unix_epoch = TimeZones.datetime2unix(
        Dates.DateTime(
            zoned_date_time_utc
        )
    )
    return float_number_of_seconds_since_the_unix_epoch
end

function integer_seconds_since_the_epoch_utc(zoned_date_time::TimeZones.ZonedDateTime)
    float_number_of_seconds_since_the_unix_epoch = seconds_since_the_epoch_utc(
        zoned_date_time
    )
    integer_number_of_seconds_since_the_unix_epoch = round(
        Int,
        float_number_of_seconds_since_the_unix_epoch,
    )
    return integer_number_of_seconds_since_the_unix_epoch
end
