import React from 'react'
import { shallow } from 'enzyme'
import renderer from 'react-test-renderer'

import Greeter from '../Greeter'

it('renders without crashing', () => {
  shallow(<Greeter />)
})

it('matches the snapshot', () => {
  const tree = renderer.create(<Greeter name='lodi' />).toJSON()

  expect(tree).toMatchSnapshot()
})
