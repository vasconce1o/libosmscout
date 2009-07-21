/*
  TravelJinni - Openstreetmap offline viewer
  Copyright (C) 2009  Tim Teulings

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#include <osmscout/WayIndex.h>

#include <cassert>
#include <fstream>
#include <iostream>

WayIndex::WayIndex()
{
  // no code
}

WayIndex::~WayIndex()
{
  // no code
}

bool WayIndex::LoadWayIndex(const std::string& path)
{
  std::ifstream indexFile;
  std::string   file=path+"/"+"way.idx";

  indexFile.open(file.c_str(),std::ios::in|std::ios::binary);

  if (!indexFile) {
    return false;
  }

  size_t intervalCount;

  indexFile.read((char*)&intervalSize,sizeof(intervalSize)); // Size of interval
  indexFile.read((char*)&intervalCount,sizeof(intervalCount)); // Number of intervals

  std::cout << intervalCount << " entries..." << std::endl;

  for (size_t i=0; i<intervalCount; i++) {
    IndexEntry entry;
    size_t     interval;

    indexFile.read((char*)&interval,sizeof(interval)); // The interval
    indexFile.read((char*)&entry.offset,sizeof(entry.offset));     // The offset into the way.dat file
    indexFile.read((char*)&entry.count,sizeof(entry.count)); // The number of ways in theinterval

    wayIndex[interval]=entry;
  }

  if (!indexFile) {
    indexFile.close();
    return false;
  }

  indexFile.close();
  return true;
}

size_t WayIndex::GetIntervalSize() const
{
  return intervalSize;
}

void WayIndex::GetWayIndexEntries(const std::set<Id>& wayIds, std::list<WayIndexEntry>& entries) const
{
  std::set<size_t> intervals;

  for (std::set<Id>::const_iterator way=wayIds.begin();
       way!=wayIds.end();
       ++way) {
    intervals.insert(*way/intervalSize);
  }

  for (std::set<size_t>::const_iterator interval=intervals.begin();
       interval!=intervals.end();
       ++interval) {
    std::map<size_t,IndexEntry>::const_iterator entry;

    entry=wayIndex.find(*interval);

    assert(entry!=wayIndex.end());

    WayIndexEntry tmp;

    tmp.interval=entry->first;;
    tmp.offset=entry->second.offset;
    tmp.count=entry->second.count;

    entries.push_back(tmp);
  }
}

void WayIndex::GetWayPagesIndexEntries(const std::set<Page>& pages,
                                       std::list<WayIndexEntry>& entries) const
{
  for (std::set<size_t>::const_iterator page=pages.begin();
       page!=pages.end();
       ++page) {
    std::map<size_t,IndexEntry>::const_iterator entry;

    entry=wayIndex.find(*page);

    assert(entry!=wayIndex.end());

    WayIndexEntry tmp;

    tmp.interval=entry->first;;
    tmp.offset=entry->second.offset;
    tmp.count=entry->second.count;

    entries.push_back(tmp);
  }
}

void WayIndex::DumpStatistics()
{
  size_t memory=0;

  memory+=wayIndex.size()*sizeof(size_t);     // Key
  memory+=wayIndex.size()*sizeof(IndexEntry); // Value

  std::cout << "Way index size " << wayIndex.size() << ", memory usage " << memory << std::endl;
}


