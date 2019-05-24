import React from 'react'
import { render, cleanup } from 'react-testing-library'

import Greeter from '../Greeter'

afterEach(cleanup)

it('renders without crashing', () => {
  const co = render(<Greeter name='lodi' />)

  co.getByTestId('greeter')
})
