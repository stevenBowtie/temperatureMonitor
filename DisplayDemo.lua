--Yellow is 16px tall starting at 0
dht_pin = 7
sda = 5
scl = 6
tempstr = ''
i2c.setup(0, sda, scl, i2c.SLOW)
sla = 0x3c
disp = u8g.ssd1306_128x64_i2c(sla)
disp:begin()
disp:setFont(u8g.font_chikita)

function updateDisplay()
    disp:firstPage()
    while disp:nextPage() do
        --disp:drawBox(0,16,20,15);
        disp:drawStr(10,29,tempstr)
    end
end

function updateDht()
status, temp, humi, temp_dec, humi_dec = dht.read(dht_pin)
    if status == dht.OK then
        -- Integer firmware using this example
        tempstr=string.format("%d.%d C Humid:%d.%d\r\n",
              temp,
              temp_dec/100,
              humi,
              humi_dec/100
        )
    end
end

function updateAll()
updateDht()
updateDisplay()
end

theloop = tmr.create()
theloop.register(0,500,tmr.ALARM_AUTO, updateAll)
theloop.start(0)