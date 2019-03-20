import React from 'react'
import { shallow } from 'enzyme'
import Greeter from '../Greeter'

it('renders without crashing', () => {
  shallow(<Greeter />)
})
