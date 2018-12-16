require "http"

def checkManifest(url)
  if(url =~ /manifest.mpd/)
    return true
  else
    return false
  end
end

def hashManifest(manifest)
  hash = Hash.new
  hash['timescale'] = Array.new
  hash['duration'] = Array.new
  hash['starts'] = Array.new
  hash['media'] = Array.new
  hash['init'] = Array.new
  hash['id'] = Array.new
  manifest.each_line do |line|
    if(line =~ /mediaPresentationDuration/)
      hash['length'] = line.split('"')[1].split('\\')[0]
    end
    if(line =~ /timescale/)
      hash['timescale'].push(line.split('"')[1].split('"')[0])
    end
    if(line =~ /duration/)
      hash['duration'].push(line.split('"')[1].split('"')[0])
    end
    if(line =~ /media/ && line =~ /http/)
      hash['media'].push(line.split('"')[1].split('"')[0])
    end
    if(line =~ /init/ && line =~ /http/)
      hash['init'].push(line.split('"')[1].split('"')[0])
    end
    if(line =~ /id/)
      hash['id'].push(line.split('"')[1].split('"')[0])
    end
  end
  return hash
end

def downloads(hashed, fragments)
  i = 0
  while i <= fragments
    link =  hashed["media"][0]
    link.sub! '$Number$' i.to_s
    link.sub! '$Number$' hashed["id"][2]
    puts link
    
  end
end

def timeCalc(hashed)
  fragments = hashed["length"].split('T')[1].split('.')[0].to_i/(hashed["duration"][0].to_i/1000)
  puts "--------------- VIDEO ---------------"
  puts "Duration: #{hashed["duration"][0]}ms."  
  puts "Timescale: #{hashed["timescale"][0]}ms."  
  puts "Fragments of: #{hashed["duration"][0].to_i/hashed["timescale"][0].to_i}s."
  puts "Length: #{hashed["length"].split('T')[1].split('.')[0]}s."
  puts "Nº Fragments #{fragments}"
  puts "--------------- AUDIO ---------------"
  puts "Duration: #{hashed["duration"][1]}ms."  
  puts "Timescale: #{hashed["timescale"][1]}ms."  
  puts "Fragments of: #{hashed["duration"][1].to_i/hashed["timescale"][1].to_i}s."
  puts "Length: #{hashed["length"].split('T')[1].split('.')[0]}s."
  puts "-------------------------------------"
  downloads(hashed, fragments)  
end

def downloadManifest(url)
  manifest = HTTP.get(url).to_s
  hashed = hashManifest(manifest)
  parts = timeCalc(hashed)
end

def main
  #puts "Manifest url: "
  #url = gets.chomp
  url = 'https://cloud-a13202-76-39.streamplay.to/dash/h75fuc7ocdekalhulm3depgsjn3xusyahnwrwwhqa4dvagdbq3p5ahvkvqxa/manifest.mpd'

  if(checkManifest(url) == true)
    downloadManifest(url)
  else
    puts "This link doesnt have a manifest.mpd"
  end

end

main

# https://cloud-a13202-76-39.streamplay.to/dash/h75fuc7ocdekalhulm3depgsjn3xusyahnwrwwhqa4dvagdbq3p5ahvkvqxa/manifest.mpd