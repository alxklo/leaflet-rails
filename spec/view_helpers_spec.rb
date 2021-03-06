require 'spec_helper'

describe Leaflet::ViewHelpers do
  
  class TestView < ActionView::Base
  end
  
  before :all do
    Leaflet.tile_layer = "http://{s}.somedomain.com/blabla/{z}/{x}/{y}.png"
    Leaflet.attribution = "Some attribution statement"
    Leaflet.max_zoom = 18
    
    @view = TestView.new
  end
  
  it 'should mix in view helpers on initialization' do
    @view.should respond_to(:map)
  end
  
  it 'should set the method configuration options' do    
    result = @view.map(:center => {
	      :latlng => [51.52238797921441, -0.08366235665359283],
	      :zoom => 18
	  	})
	  
	  result.should match(/L.tileLayer\('http:\/\/{s}.somedomain\.com\/blabla\/{z}\/{x}\/{y}\.png'/)
	  result.should match(/attribution: 'Some attribution statement'/)
	  result.should match(/maxZoom: 18/)
  end
  
  it 'should generate a basic map with the correct latitude, longitude and zoom' do
    result = @view.map(:center => {
	      :latlng => [51.52238797921441, -0.08366235665359283],
	      :zoom => 18
	  	})
	  result.should match(/map\.setView\(\[51.52238797921441, -0.08366235665359283\], 18\)/)
  end
  
  it 'should generate a marker' do
    result = @view.map(:center => {
	      :latlng => [51.52238797921441, -0.08366235665359283],
	      :zoom => 18
	  	},
	  	:markers => [
           {
             :latlng => [51.52238797921441, -0.08366235665359283],
           }
        ])
    result.should match(/marker = L\.marker\(\[51.52238797921441, -0.08366235665359283\]\).addTo\(map\)/)
  end
  
  it 'should generate a marker with a popup' do
    result = @view.map(:center => {
	      :latlng => [51.52238797921441, -0.08366235665359283],
	      :zoom => 18
	  	},
	  	:markers => [
           {
             :latlng => [51.52238797921441, -0.08366235665359283],
             :popup => "Hello!"
           }
        ])
    result.should match(/marker = L\.marker\(\[51.52238797921441, -0.08366235665359283\]\).addTo\(map\)/)
    result.should match(/marker\.bindPopup\('Hello!'\)/)
  end
  
  it 'should override the method configuration options if set' do
    result = @view.map(:center => {
	      :latlng => [51.52238797921441, -0.08366235665359283],
	      :zoom => 18
	  	},
	  	:tile_layer => "http://{s}.someotherdomain.com/blabla/{z}/{x}/{y}.png",
	  	:attribution => "Some other attribution text",
	  	:max_zoom => 4
	  	)
	  
  	  result.should match(/L.tileLayer\('http:\/\/{s}.someotherdomain\.com\/blabla\/{z}\/{x}\/{y}\.png'/)
  	  result.should match(/attribution: 'Some other attribution text'/)
  	  result.should match(/maxZoom: 4/)
  end

  it 'should have multiple map on single page' do
    result = @view.map(:container_id => "first_map", :center => {
              :latlng => [51.52238797921441, -0.08366235665359283],
                })

    result1 = @view.map(:container_id => "second_map", :center => {
              :latlng => [51.62238797921441, -0.08366235665359284],
                })

          result.should match(/id=\'first_map'/)
          result.should match(/L.map\('first_map'/)

          result1.should match(/id=\'second_map'/)
          result1.should match(/L.map\('second_map'/)

  end
 
  it 'should generate a map and add a circle' do
    result = @view.map(
                :container_id => "first_map",
                :center => {
                  :latlng => [51.52238797921441, -0.08366235665359283]
                },
                :circles => [
                  {
                    :latlng => [51.52238797921441, -0.08366235665359283],
                    :radius => 12,
                    :color => 'red',
                    :fillColor => '#f03',
                    :fillOpacity => 0.5
                  }
                  ])
    result.should match(/L.circle\(\[\'51.52238797921441\', \'-0.08366235665359283\'\], 12, \{
           color: \'red\',
           fillColor: \'#f03\',
           fillOpacity: 0.5
        \}\).addTo\(map\)/)
  end

  it 'should not create the container tag if no_container is set' do
    result = @view.map(:center => {
        :latlng => [51.52238797921441, -0.08366235665359283],
        :zoom => 18
      },
      :no_container => true
      )

    result.should_not match(/<div id='map'>/)
  end

end
