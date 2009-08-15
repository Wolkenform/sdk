////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007-2009, Daniel Gasienica <daniel@gasienica.ch>
//
//  OpenZoom is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  OpenZoom is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.descriptors.deepzoom
{

import org.flexunit.Assert
import org.openzoom.flash.descriptors.IImagePyramidDescriptor
import org.openzoom.flash.descriptors.IImagePyramidLevel

/**
 * Tests the DeepZoomImageDescriptor implementation for correctness.
 */
public class DeepZoomImageDescriptorTest
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    private static const DESCRIPTOR_XML:XML =
        <Image xmlns="http://schemas.microsoft.com/deepzoom/2008"
               TileSize="100" Overlap="0" Format="jpg">
            <Size Width="2592" Height="3872"/>
        </Image>;

    private static const LEVELS:Array =
        [// width, height, columns, rows
            [1,      1,       1,    1],
            [2,      2,       1,    1],
            [3,      4,       1,    1],
            [6,      8,       1,    1],
            [11,    16,       1,    1],
            [21,    31,       1,    1],
            [41,    61,       1,    1],
            [81,   121,       1,    2],
            [162,   242,       2,    3],
            [324,   484,       4,    5],
            [648,   968,       7,   10],
            [1296,  1936,      13,   20],
            [2592,  3872,      26,   39],
    ]

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    private var descriptor:IImagePyramidDescriptor

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: TestCase
    //
    //--------------------------------------------------------------------------

    [Before]
    public function setUp():void
    {
        descriptor = DeepZoomImageDescriptor.fromXML("test.xml", DESCRIPTOR_XML)
    }

    [After]
    public function tearDown():void
    {
        descriptor = null
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Tests
    //
    //--------------------------------------------------------------------------

    [Test]
    public function testMaxLevel():void
    {
        Assert.assertEquals("Maximum level correctly computed", 12, descriptor.numLevels - 1)
    }

    [Test]
    public function testOverlap():void
    {
        Assert.assertEquals("Overlap correct", 0, descriptor.tileOverlap)
    }

    [Test]
    public function testLevels():void
    {
       for (var index:int = 0; index < descriptor.numLevels; index++)
       {
            var level:IImagePyramidLevel = descriptor.getLevelAt(index)
            Assert.assertEquals("Width on level "        + level.index, LEVELS[level.index][0], level.width)
            Assert.assertEquals("Height on level "       + level.index, LEVELS[level.index][1], level.height)
            Assert.assertEquals("Column count on level " + level.index, LEVELS[level.index][2], level.numColumns)
            Assert.assertEquals("Row count on level "    + level.index, LEVELS[level.index][3], level.numRows)
       }

    }

    [Test]
    public function testGetLevelForSize():void
    {
        Assert.assertEquals("Level computation for given size", descriptor.numLevels - 1,
            descriptor.getLevelForSize(descriptor.width, descriptor.height).index)

        Assert.assertEquals("Level computation for given size", descriptor.numLevels - 2,
            descriptor.getLevelForSize(descriptor.width / 2 - 1, descriptor.height / 2 - 1).index)
    }
}

}
