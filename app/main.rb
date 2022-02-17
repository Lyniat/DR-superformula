WIDTH = 1280
HEIGHT = 720
DEG2RAD = 0.01745329251

def tick args

  t = args.state.tick_count

  r = 300
  m = 8
  n1 = 2 + Math.sin(t / 100).abs * 30
  n2 = 6 + Math.sin(t / 70).abs * 30
  n3 = 3 + Math.sin(t / 40).abs * 30
  a = 1
  b = 1
  lines = 3

  distance = 0

  k = 0
  while k < lines
    i = -1
    while i < 360

      mp = (m / 4) * (i + t) * DEG2RAD

      radiant = i * DEG2RAD
      old_radiant = (i-1) * DEG2RAD
      old_distance = distance
      distance = (r-k) * (((1 / a) * Math.cos(mp)).abs**n2 + ((1 / b) * Math.sin(mp)).abs**n3)**(1/n1)

      if i == -1
        i += 1
        next
      end

      x_0 = old_distance * Math.cos(old_radiant) + WIDTH / 2
      y_0 = old_distance * Math.sin(old_radiant) + HEIGHT / 2

      x_1 = distance * Math.cos(radiant) + WIDTH / 2
      y_1 = distance * Math.sin(radiant) + HEIGHT / 2

      cr, cg, cb = hsl_to_rgb(i/360, 1, 0.5)

      args.outputs.lines << [x_0, y_0, x_1, y_1, cr, cb, cg, 255]
      i += 1
    end
    k += 1
  end
end

# optional colors by Anil Yanduri
# see https://github.com/anilyanduri/color_math/blob/master/lib/color_math.rb
def hsl_to_rgb(h, s, l)
  r = 0.0
  g = 0.0
  b = 0.0

  if s == 0.0
    r = l.to_f
    g = l.to_f
    b = l.to_f #achromatic
  else
    q = l < 0.5 ? l * (1 + s) : l + s - l * s
    p = 2 * l - q
    r = hue_to_rgb(p, q, h + 1/3.0)
    g = hue_to_rgb(p, q, h)
    b = hue_to_rgb(p, q, h - 1/3.0)
  end

  return [(r * 255).round, (g * 255).round, (b * 255).round]
end

def hue_to_rgb(p, q, t)
  t += 1                                  if(t < 0)
  t -= 1                                  if(t > 1)
  return (p + (q - p) * 6 * t)            if(t < 1/6.0)
  return q                                if(t < 1/2.0)
  return (p + (q - p) * (2/3.0 - t) * 6)  if(t < 2/3.0)
  return p
end
