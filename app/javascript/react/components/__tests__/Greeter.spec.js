import React from 'react'
import { render, cleanup } from '@testing-library/react'

import Greeter from '../Greeter'

afterEach(cleanup)

it('renders without crashing', () => {
  const co = render(<Greeter message='Hey!' />)

  co.getByTestId('greeter')
})
